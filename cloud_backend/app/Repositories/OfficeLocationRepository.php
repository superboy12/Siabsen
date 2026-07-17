<?php

namespace App\Repositories;

use App\Models\OfficeLocation;
use Illuminate\Database\Eloquent\Collection;

class OfficeLocationRepository
{
    public function all(): Collection
    {
        return OfficeLocation::all();
    }

    public function find(int $id): ?OfficeLocation
    {
        return OfficeLocation::find($id);
    }

    public function create(array $data): OfficeLocation
    {
        return OfficeLocation::create($data);
    }

    public function update(OfficeLocation $location, array $data): OfficeLocation
    {
        $location->update($data);
        return $location;
    }

    public function delete(OfficeLocation $location): bool
    {
        return $location->delete();
    }
}
