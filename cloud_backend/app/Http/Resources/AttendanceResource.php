<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AttendanceResource extends JsonResource
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
            'user' => new UserResource($this->whenLoaded('user')),
            'check_in_time' => $this->check_in_time,
            'check_out_time' => $this->check_out_time,
            'check_in_photo' => $this->check_in_photo ? url('storage/' . $this->check_in_photo) : null,
            'check_out_photo' => $this->check_out_photo ? url('storage/' . $this->check_out_photo) : null,
            'latitude' => $this->latitude,
            'longitude' => $this->longitude,
            'attendance_status' => $this->attendance_status,
            'created_at' => $this->created_at,
        ];
    }
}
