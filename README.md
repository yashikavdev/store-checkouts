# Store Checkouts

## Running CLI program
make sure you have ruby >= 3 installed.

install bundler with

```gem install bundler ```

then

```bundle install```

and execute the cli program with

```ruby main.rb```

## Running Test cases

```rspec spec```


## Example Scenarios that are covered through rspec test cases

`1. Items: VOUCHER, TSHIRT, MUG
Total: 32.50 $`

`2. Items: VOUCHER, TSHIRT, VOUCHER
Total: 25.00 $`

`3. Items: TSHIRT, TSHIRT, TSHIRT, VOUCHER, TSHIRT
Total: 81.00 $`

`4. Items: VOUCHER, TSHIRT, VOUCHER, VOUCHER, MUG, TSHIRT, TSHIRT
Total: 74.50 $`