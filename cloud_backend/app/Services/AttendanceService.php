<?php

namespace App\Services;

use App\Repositories\AttendanceRepository;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Str;
use App\Models\User;
use App\Models\AttendanceLog;
use Carbon\Carbon;
use Illuminate\Support\Facades\Storage;

class AttendanceService
{
    public function __construct(
        protected AttendanceRepository $attendanceRepository
    ) {}

    public function checkIn(User $user, array $data, $photoFile): \App\Models\Attendance
    {
        $todayAttendance = $this->attendanceRepository->getTodayAttendance($user->id);

        if ($todayAttendance) {
            throw ValidationException::withMessages([
                'attendance' => ['You have already checked in today.'],
            ]);
        }

        // Validate Location
        $this->validateLocation($user, $data['latitude'], $data['longitude']);

        $photoPath = null;
        if ($photoFile) {
            $filename = Str::uuid() . '.' . $photoFile->getClientOriginalExtension();
            $photoPath = $photoFile->storeAs('attendances', $filename, 'public');
        }

        $attendance = $this->attendanceRepository->create([
            'user_id' => $user->id,
            'check_in_time' => Carbon::now(),
            'check_in_photo' => $photoPath,
            'latitude' => $data['latitude'],
            'longitude' => $data['longitude'],
            'attendance_status' => $this->calculateStatus(),
        ]);

        AttendanceLog::create([
            'attendance_id' => $attendance->id,
            'activity' => 'check_in',
            'description' => 'User checked in successfully.',
        ]);

        return $attendance;
    }

    public function checkOut(User $user, array $data, $photoFile): \App\Models\Attendance
    {
        $attendance = $this->attendanceRepository->getTodayAttendance($user->id);

        if (!$attendance) {
            throw ValidationException::withMessages([
                'attendance' => ['You have not checked in today.'],
            ]);
        }

        if ($attendance->check_out_time) {
            throw ValidationException::withMessages([
                'attendance' => ['You have already checked out today.'],
            ]);
        }

        // Validate Location
        $this->validateLocation($user, $data['latitude'], $data['longitude']);

        $photoPath = null;
        if ($photoFile) {
            $filename = Str::uuid() . '.' . $photoFile->getClientOriginalExtension();
            $photoPath = $photoFile->storeAs('attendances', $filename, 'public');
        }

        $attendance = $this->attendanceRepository->update($attendance, [
            'check_out_time' => Carbon::now(),
            'check_out_photo' => $photoPath,
        ]);

        AttendanceLog::create([
            'attendance_id' => $attendance->id,
            'activity' => 'check_out',
            'description' => 'User checked out successfully.',
        ]);

        return $attendance;
    }

    public function getTodayAttendance(int $userId)
    {
        return $this->attendanceRepository->getTodayAttendance($userId);
    }

    public function getHistory(int $userId)
    {
        return $this->attendanceRepository->getHistory($userId);
    }

    protected function validateLocation(User $user, $lat, $lng)
    {
        // Simple distance calculation (Haversine)
        $office = App\Models\OfficeLocation::first();
        if (!$office) return true; // No office configured

        $earthRadius = 6371000; // meters
        $latFrom = deg2rad($lat);
        $lonFrom = deg2rad($lng);
        $latTo = deg2rad($office->latitude);
        $lonTo = deg2rad($office->longitude);

        $latDelta = $latTo - $latFrom;
        $lonDelta = $lonTo - $lonFrom;

        $angle = 2 * asin(sqrt(pow(sin($latDelta / 2), 2) +
          cos($latFrom) * cos($latTo) * pow(sin($lonDelta / 2), 2)));
        $distance = $angle * $earthRadius;

        if ($distance > $office->radius) {
            throw ValidationException::withMessages([
                'location' => ['You are out of the office radius.'],
            ]);
        }
    }

    protected function calculateStatus()
    {
        // Simple mock for now: present if before 09:00, late if after
        $now = Carbon::now();
        if ($now->hour >= 9) {
            return 'late';
        }
        return 'present';
    }
}
