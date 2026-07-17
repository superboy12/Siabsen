<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use App\Models\Role;
use App\Models\Department;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $adminRole = Role::where('role_name', 'Super Admin')->first();
        $userRole = Role::where('role_name', 'User')->first();
        $itDept = Department::where('department_name', 'IT')->first();

        User::create([
            'employee_number' => 'EMP-001',
            'name' => 'Super Admin',
            'email' => 'admin@demo.com',
            'password' => Hash::make('password'),
            'department_id' => $itDept->id,
            'role_id' => $adminRole->id,
            'status' => 'active',
        ]);

        User::create([
            'employee_number' => 'EMP-002',
            'name' => 'John Doe',
            'email' => 'user@demo.com',
            'password' => Hash::make('password'),
            'department_id' => $itDept->id,
            'role_id' => $userRole->id,
            'status' => 'active',
        ]);
    }
}
