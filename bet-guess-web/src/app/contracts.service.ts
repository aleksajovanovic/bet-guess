import * as Web3 from 'web3'; 
import { Injectable } from '@angular/core';

declare let require: any;
declare let window: any;

let contractAbi = require('./smart-contracts/betGuessAbi.json');

@Injectable()
export class ContractsService {
  private _account: string = null;
  private _web3: any;
  private web3: any = Web3;
  private _contract: any;
  private _contractAddress: string = "0x3390a68567B8981bCA2eeBbddc4fD074Bb64675A";

  constructor() { 
    if (typeof window.web3 !== 'undefined') {
      this._web3 = new Web3(window.web3.currentProvider);

      if (this._web3.version.network !== '4') {
        alert('Please connect to the Rinkeby network');
      }
    }
    else {
      console.warn('Please use a dapp browser like mist or MetaMask plugin for chrome');
    }

    this._contract = new this._web3.eth.Contract(contractAbi);
    this._contract.options.address = this._contractAddress;
  }

  private async getAccount(): Promise<string> {
    if (this._account == null) {
      this._account = await new Promise((resolve, reject) => {
        this._web3.eth.getAccounts((err, accs) => {
          if (err != null) {
            alert('There was an error fetching your accounts.');
            return;
          }
  
          if (accs.length === 0) {
            alert(
              'Couldn\'t get any accounts! Make sure your Ethereum client is configured correctly.'
            );
            return;
          }
          resolve(accs[0]);
        })
      }) as string;
  
      this._web3.eth.defaultAccount = this._account;
    }
  
    return Promise.resolve(this._account);
  }

  async getUsersBalance(): Promise<number> {
    let account = await this.getAccount();

    return new Promise((resolve, reject) => {
      let _web3 = this._web3;
      _web3.eth.getBalance(account, (err, result) => {
        if (err != null) {
          reject(err);
        }

        resolve(result);
      });
    }) as Promise<number>;
  }

  
}
