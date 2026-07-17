<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\OfficeLocation;

class OfficeLocationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        OfficeLocation::create([
            'office_name' => 'Main HQ',
            'latitude' => -6.200000, // Example Jakarta coordinates
            'longitude' => 106.816666,
            'radius' => 100, // 100 meters
        ]);
    }
}
