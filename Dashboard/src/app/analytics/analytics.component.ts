import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';

@Component({
  selector: 'app-analytics',
  templateUrl: './analytics.component.html',
  styleUrl: './analytics.component.css'
})
export class AnalyticsComponent implements OnInit {
  showAnalytics = false;

  toggleAnalytics() {
    this.showAnalytics = !this.showAnalytics;
  }
  title='Dashboard';
  days: (number | null)[] = [];
  weekdays: string[] = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  currentMonth: number = new Date().getMonth();
  currentYear: number = new Date().getFullYear();
  monthName: string = new Date().toLocaleString('default', { month: 'long' });

  constructor(private router: Router) {}

  ngOnInit(): void {
    this.generateCalendar(this.currentMonth, this.currentYear);
  }

  generateCalendar(month: number, year: number): void {
    this.days = [];
    const firstDay = new Date(year, month, 1).getDay();
    const lastDate = new Date(year, month + 1, 0).getDate();

   
    for (let i = 0; i < firstDay; i++) {
      this.days.push(null);
    }

   
    for (let date = 1; date <= lastDate; date++) {
      this.days.push(date);
    }
  }

  nextMonth(): void {
    if (this.currentMonth === 11) {
      this.currentMonth = 0;
      this.currentYear++;
    } else {
      this.currentMonth++;
    }
    this.updateMonthName();
    this.generateCalendar(this.currentMonth, this.currentYear);
  }

  prevMonth(): void {
    if (this.currentMonth === 0) {
      this.currentMonth = 11;
      this.currentYear--;
    } else {
      this.currentMonth--;
    }
    this.updateMonthName();
    this.generateCalendar(this.currentMonth, this.currentYear);
  }

  private updateMonthName(): void {
    this.monthName = new Date(this.currentYear, this.currentMonth).toLocaleString('default', { month: 'long' });
  }
}

