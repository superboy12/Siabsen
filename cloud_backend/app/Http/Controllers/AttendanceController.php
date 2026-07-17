<?php

namespace App\Http\Controllers;

use App\Http\Requests\CheckInRequest;
use App\Http\Requests\CheckOutRequest;
use App\Http\Resources\AttendanceResource;
use App\Services\AttendanceService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AttendanceController extends Controller
{
    public function __construct(
        protected AttendanceService $attendanceService
    ) {}

    public function checkIn(CheckInRequest $request): JsonResponse
    {
        $attendance = $this->attendanceService->checkIn(
            $request->user(),
            $request->validated(),
            $request->file('photo')
        );

        return response()->json([
            'success' => true,
            'message' => 'Check in successful',
            'data' => new AttendanceResource($attendance),
        ], 201);
    }

    public function checkOut(CheckOutRequest $request): JsonResponse
    {
        $attendance = $this->attendanceService->checkOut(
            $request->user(),
            $request->validated(),
            $request->file('photo')
        );

        return response()->json([
            'success' => true,
            'message' => 'Check out successful',
            'data' => new AttendanceResource($attendance),
        ]);
    }

    public function today(Request $request): JsonResponse
    {
        $attendance = $this->attendanceService->getTodayAttendance($request->user()->id);

        return response()->json([
            'success' => true,
            'message' => 'Today attendance retrieved successfully',
            'data' => $attendance ? new AttendanceResource($attendance) : null,
        ]);
    }

    public function history(Request $request): JsonResponse
    {
        $history = $this->attendanceService->getHistory($request->user()->id);

        return response()->json([
            'success' => true,
            'message' => 'Attendance history retrieved successfully',
            'data' => AttendanceResource::collection($history),
        ]);
    }
}
