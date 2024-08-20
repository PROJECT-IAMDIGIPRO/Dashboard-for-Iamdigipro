import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { AnalyticsComponent } from './analytics/analytics.component';
import { TicketsComponent } from './tickets/tickets.component';
import { TimesheetComponent } from './timesheet/timesheet.component';
import { CalendarComponent } from './calendar/calendar.component';
import { PermissionsComponent } from './permissions/permissions.component';
import { EmployeesComponent } from './employees/employees.component';

@NgModule({
  declarations: [
    AppComponent,
    AnalyticsComponent,
    TicketsComponent,
    TimesheetComponent,
    CalendarComponent,
    PermissionsComponent,
    EmployeesComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
