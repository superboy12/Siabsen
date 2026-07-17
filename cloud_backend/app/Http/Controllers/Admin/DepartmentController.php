<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Repositories\DepartmentRepository;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DepartmentController extends Controller
{
    public function __construct(
        protected DepartmentRepository $departmentRepository
    ) {}

    public function index(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $this->departmentRepository->all(),
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'department_name' => 'required|string|max:255',
        ]);

        $department = $this->departmentRepository->create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Department created successfully',
            'data' => $department,
        ], 201);
    }

    public function show(int $id): JsonResponse
    {
        $department = $this->departmentRepository->find($id);
        if (!$department) {
            return response()->json(['success' => false, 'message' => 'Department not found'], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $department,
        ]);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $department = $this->departmentRepository->find($id);
        if (!$department) {
            return response()->json(['success' => false, 'message' => 'Department not found'], 404);
        }

        $validated = $request->validate([
            'department_name' => 'required|string|max:255',
        ]);

        $department = $this->departmentRepository->update($department, $validated);

        return response()->json([
            'success' => true,
            'message' => 'Department updated successfully',
            'data' => $department,
        ]);
    }

    public function destroy(int $id): JsonResponse
    {
        $department = $this->departmentRepository->find($id);
        if (!$department) {
            return response()->json(['success' => false, 'message' => 'Department not found'], 404);
        }

        $this->departmentRepository->delete($department);

        return response()->json([
            'success' => true,
            'message' => 'Department deleted successfully',
        ]);
    }
}
