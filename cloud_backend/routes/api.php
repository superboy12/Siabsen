<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    Route::prefix('attendance')->group(function () {
        Route::post('/check-in', [\App\Http\Controllers\AttendanceController::class, 'checkIn']);
        Route::post('/check-out', [\App\Http\Controllers\AttendanceController::class, 'checkOut']);
        Route::get('/today', [\App\Http\Controllers\AttendanceController::class, 'today']);
        Route::get('/history', [\App\Http\Controllers\AttendanceController::class, 'history']);
    });

    Route::middleware('role:Super Admin')->prefix('admin')->group(function () {
        // Dashboard
        Route::get('/dashboard/statistics', [\App\Http\Controllers\Admin\DashboardController::class, 'statistics']);
        
        // CRUD Users
        Route::apiResource('/users', \App\Http\Controllers\Admin\UserController::class);
        
        // CRUD Departments
        Route::apiResource('/departments', \App\Http\Controllers\Admin\DepartmentController::class);
        
        // CRUD Office Locations
        Route::apiResource('/office-locations', \App\Http\Controllers\Admin\OfficeLocationController::class);
        
        // Exports
        Route::get('/exports/attendances', [\App\Http\Controllers\Admin\ExportController::class, 'attendances']);
    });
});
