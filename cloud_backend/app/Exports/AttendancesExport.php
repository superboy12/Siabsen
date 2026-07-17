<?php

namespace App\Exports;

use App\Models\Attendance;
use Maatwebsite\Excel\Concerns\FromCollection;
use Maatwebsite\Excel\Concerns\WithHeadings;
use Maatwebsite\Excel\Concerns\WithMapping;

class AttendancesExport implements FromCollection, WithHeadings, WithMapping
{
    public function __construct(
        protected ?string $startDate = null,
        protected ?string $endDate = null
    ) {}

    /**
    * @return \Illuminate\Support\Collection
    */
    public function collection()
    {
        $query = Attendance::with('user.department');

        if ($this->startDate && $this->endDate) {
            $query->whereBetween('created_at', [$this->startDate, $this->endDate]);
        }

        return $query->get();
    }

    public function headings(): array
    {
        return [
            'ID',
            'Employee Number',
            'Name',
            'Department',
            'Check In Time',
            'Check Out Time',
            'Status',
            'Date',
        ];
    }

    public function map($attendance): array
    {
        return [
            $attendance->id,
            $attendance->user->employee_number ?? '-',
            $attendance->user->name ?? '-',
            $attendance->user->department->department_name ?? '-',
            $attendance->check_in_time ? $attendance->check_in_time->format('H:i:s') : '-',
            $attendance->check_out_time ? $attendance->check_out_time->format('H:i:s') : '-',
            ucfirst($attendance->attendance_status),
            $attendance->created_at->format('Y-m-d'),
        ];
    }
}
