<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Repositories\OfficeLocationRepository;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class OfficeLocationController extends Controller
{
    public function __construct(
        protected OfficeLocationRepository $officeLocationRepository
    ) {}

    public function index(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => $this->officeLocationRepository->all(),
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'office_name' => 'required|string|max:255',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'radius' => 'required|integer|min:1',
        ]);

        $location = $this->officeLocationRepository->create($validated);

        return response()->json([
            'success' => true,
            'message' => 'Office location created successfully',
            'data' => $location,
        ], 201);
    }

    public function show(int $id): JsonResponse
    {
        $location = $this->officeLocationRepository->find($id);
        if (!$location) {
            return response()->json(['success' => false, 'message' => 'Office location not found'], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $location,
        ]);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $location = $this->officeLocationRepository->find($id);
        if (!$location) {
            return response()->json(['success' => false, 'message' => 'Office location not found'], 404);
        }

        $validated = $request->validate([
            'office_name' => 'required|string|max:255',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
            'radius' => 'required|integer|min:1',
        ]);

        $location = $this->officeLocationRepository->update($location, $validated);

        return response()->json([
            'success' => true,
            'message' => 'Office location updated successfully',
            'data' => $location,
        ]);
    }

    public function destroy(int $id): JsonResponse
    {
        $location = $this->officeLocationRepository->find($id);
        if (!$location) {
            return response()->json(['success' => false, 'message' => 'Office location not found'], 404);
        }

        $this->officeLocationRepository->delete($location);

        return response()->json([
            'success' => true,
            'message' => 'Office location deleted successfully',
        ]);
    }
}
