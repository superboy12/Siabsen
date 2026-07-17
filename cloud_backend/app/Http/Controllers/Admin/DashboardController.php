<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Attendance;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function statistics(Request $request): JsonResponse
    {
        $today = Carbon::today();

        $totalUsers = User::count();
        $totalPresentToday = Attendance::whereDate('created_at', $today)->count();
        $totalLateToday = Attendance::whereDate('created_at', $today)
            ->where('attendance_status', 'late')
            ->count();

        return response()->json([
            'success' => true,
            'data' => [
                'total_users' => $totalUsers,
                'present_today' => $totalPresentToday,
                'late_today' => $totalLateToday,
                'absent_today' => $totalUsers - $totalPresentToday,
            ],
        ]);
    }
}
