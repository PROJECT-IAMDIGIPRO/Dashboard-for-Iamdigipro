import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { CalendarComponent } from './calendar/calendar.component';
import { TicketsComponent } from './tickets/tickets.component';
import { AnalyticsComponent } from './analytics/analytics.component';
import { TimeSheetComponent } from './time-sheet/time-sheet.component';
import { PermissionsComponent } from './permissions/permissions.component';
import { EmployeesComponent } from './employees/employees.component';

@NgModule({
  declarations: [
    AppComponent,
    CalendarComponent,
    TicketsComponent,
    AnalyticsComponent,
    TimeSheetComponent,
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
