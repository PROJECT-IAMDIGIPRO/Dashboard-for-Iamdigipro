import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { TicketsComponent } from './tickets/tickets.component';  
import { CalendarComponent } from './calendar/calendar.component';
import { EmployeesComponent} from './employees/employees.component';
import { TimesheetComponent} from './timesheet/timesheet.component';
import { PermissionsComponent} from './permissions/permissions.component';
import {AnalyticsComponent} from './analytics/analytics.component';

const routes: Routes = [
  { path: 'calendar', component: CalendarComponent },  
  { path: 'tickets', component: TicketsComponent },
  { path: 'employees', component: EmployeesComponent},
  {path: 'timesheet', component: TimesheetComponent},
  {path: 'permissions', component: PermissionsComponent},
  {path: 'analytics', component: AnalyticsComponent}, 
  { path: '', redirectTo: '/calendar', pathMatch: 'full' } 
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
