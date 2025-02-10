A "zap" for Curve's strategic reserves

# Todo

- [x] zap to deposit USDC/USDT into the yearn vault (https://yearn.fi/vaults/1/0xfBd4d8bf19c67582168059332c46567563d0d75f)
- [x] zap to redeem USDC/USDT from the yearn vault (redeem means the function takes a number of shares)
- [ ] zap to withdraw USDC/USDT from the yearn vault (withdraw means the function takes the number of underlying tokens)
- [ ] a good name ("ZapStrategicReserves" is boring. "1pool" is funny. any other ideas?)
- [ ] script for claiming crvUSD from veCRV
- [ ] script for claiming yv-crvUSD-2 from st-yCRV
- [ ] zap to withdraw yv-crvUSD-2 to crvUSD and then trade it to either USDC or USDT (whatever path is better)
- [ ] script for trading crvUSD to either USDC or USDT (whatever path is better). then depositing it into the 2pool vault
- [ ] zap to deposit/withdraw into the exchange (for people that do not care about the gauge rewards)
- [ ] convince yearn to add dYFI emissions to the reserves yearn vault
- [ ] convince 1up to add support for. then update the zaps to send to 1up.
