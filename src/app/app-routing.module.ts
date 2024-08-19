import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AppComponent } from './app.component';
import { CalendarComponent } from './calendar/calendar.component';
import { TicketsComponent } from './tickets/tickets.component';
import { AnalyticsComponent } from './analytics/analytics.component';
import { TimeSheetComponent } from './time-sheet/time-sheet.component';
import { PermissionsComponent } from './permissions/permissions.component';
import { EmployeesComponent } from './employees/employees.component';

const routes: Routes = [
  
  {path:'calendar', component:CalendarComponent},
  { path: 'tickets', component: TicketsComponent },
  {path:'analytics', component:AnalyticsComponent},
  {path:'timesheet', component:TimeSheetComponent},
  {path:'permissions', component:PermissionsComponent},
  {path:'employees', component:EmployeesComponent},  
  { path: '', redirectTo: '/calendar', pathMatch: 'full' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
