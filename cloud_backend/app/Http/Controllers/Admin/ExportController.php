<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Exports\AttendancesExport;
use Illuminate\Http\Request;
use Maatwebsite\Excel\Facades\Excel;

class ExportController extends Controller
{
    public function attendances(Request $request)
    {
        $startDate = $request->query('start_date');
        $endDate = $request->query('end_date');

        $filename = 'attendances_export_' . now()->format('Y_m_d_His') . '.xlsx';

        return Excel::download(new AttendancesExport($startDate, $endDate), $filename);
    }
}
