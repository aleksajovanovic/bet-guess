import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { GuessComponent } from './guess/guess.component';
import { ContractsService } from './contracts.service';


@NgModule({
  declarations: [
    AppComponent,
    GuessComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [ContractsService],
  bootstrap: [AppComponent]
})
export class AppModule { }
