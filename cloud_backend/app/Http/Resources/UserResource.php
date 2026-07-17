<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'employee_number' => $this->employee_number,
            'name' => $this->name,
            'email' => $this->email,
            'department' => $this->whenLoaded('department', function () {
                return $this->department->department_name;
            }),
            'role' => $this->whenLoaded('role', function () {
                return $this->role->role_name;
            }),
            'photo' => $this->photo ? url('storage/' . $this->photo) : null,
            'status' => $this->status,
        ];
    }
}
