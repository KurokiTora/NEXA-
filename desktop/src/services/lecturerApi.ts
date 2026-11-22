import { apiRequest } from "./api";

export class AuthError extends Error {}

interface Envelope<T> {
  success: boolean;
  message: string;
  data: T | null;
}

export function clearSession() {
  localStorage.removeItem("nexa_token");
  localStorage.removeItem("nexa_user");
}

async function request<T>(
  path: string,
  options: { method?: string; body?: unknown } = {}
): Promise<T> {
  const token = localStorage.getItem("nexa_token");

  if (!token) {
    throw new AuthError("Authentication token is required.");
  }

  let result: Envelope<T>;

  try {
    result = await apiRequest<Envelope<T>>(path, {
      method: options.method ?? "GET",
      headers: { Authorization: `Bearer ${token}` },
      body:
        options.body !== undefined ? JSON.stringify(options.body) : undefined,
    });
  } catch (err) {
    if (err instanceof Error && /authentication token/i.test(err.message)) {
      throw new AuthError(err.message);
    }
    throw err;
  }

  if (!result.success || result.data === null) {
    if (/authentication token/i.test(result.message ?? "")) {
      throw new AuthError(result.message);
    }
    throw new Error(result.message || "Request failed.");
  }

  return result.data;
}

export interface MeData {
  id: number;
  email: string;
  role: "lecturer" | "student";
  profile: { lecturerId?: string; studentId?: string; fullName: string } | null;
}

export interface DashboardData {
  stats: {
    attendancePercentage: number | null;
    studentCount: number;
    averageGrade: number | null;
  };
  schedule: {
    id: number;
    day: string;
    classCode: string;
    room: string;
    time: string;
  }[];
}

export interface ClassSummary {
  id: number;
  courseName: string;
  classCode: string;
  studentCount: number;
}

export interface ClassDetail {
  id: number;
  courseName: string;
  classCode: string;
  students: { id: number; fullName: string; studentNumber: string }[];
}

export interface StudentDetail {
  id: number;
  fullName: string;
  studentNumber: string;
  assignments: {
    id: number;
    title: string;
    status: "Completed" | "Not Completed";
    grade: number | null;
  }[];
}

export type FeedbackStatus = "New" | "Reviewed" | "Resolved";

export interface FeedbackItem {
  id: number;
  studentId: number;
  studentName: string;
  classId: number;
  subject: string;
  message: string;
  createdAt: string;
  status: FeedbackStatus;
}

export const getMe = () => request<MeData>("/auth/me");

export const getDashboard = () => request<DashboardData>("/lecturer/dashboard");

export const getClasses = () => request<ClassSummary[]>("/lecturer/classes");

export const getClassDetail = (classId: string | number) =>
  request<ClassDetail>(`/lecturer/classes/${classId}`);

export const getStudentDetail = (
  classId: string | number,
  studentId: string | number
) =>
  request<StudentDetail>(
    `/lecturer/classes/${classId}/students/${studentId}`
  );

export const getFeedback = () => request<FeedbackItem[]>("/lecturer/feedback");

export async function requestPasswordReset(email: string): Promise<void> {
  await apiRequest<Envelope<null>>("/auth/forgot-password", {
    method: "POST",
    body: JSON.stringify({ email }),
  });
}