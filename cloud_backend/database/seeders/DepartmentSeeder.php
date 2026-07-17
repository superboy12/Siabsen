<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Department;

class DepartmentSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Department::create(['department_name' => 'IT']);
        Department::create(['department_name' => 'HR']);
        Department::create(['department_name' => 'Finance']);
    }
}
