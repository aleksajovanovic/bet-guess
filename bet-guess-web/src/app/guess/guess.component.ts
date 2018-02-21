import { Component, OnInit } from '@angular/core';
import { ContractsService } from '../contracts.service';

@Component({
  selector: 'app-guess',
  templateUrl: './guess.component.html',
  styleUrls: ['./guess.component.scss']
})
export class GuessComponent implements OnInit {

  constructor(private ContractsService: ContractsService) { }

  ngOnInit() {
  }

  guess(participantsGuess: number): void {
    this.getUsersBalance();
  }
/*
  getAccount(): void {
    this.ContractsService.getAccount()
      .then((account) => {
        console.log(account);
      })
      .catch((err) => {
        console.log(err); 
      });
  }*/

  getUsersBalance(): void {
    this.ContractsService.getUsersBalance()
      .then((balance) => {
        console.log(balance);
      })
      .catch((err) => {
        console.log(err); 
      });
  }

}
