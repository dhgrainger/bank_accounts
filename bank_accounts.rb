require'CSV'
require'pry'

def format_currency(currency)
	sprintf('$%.2f', currency)
end

class BankTransaction
	attr_accessor :date, :amount, :description, :account

	def initialize(transactions = {})
		@date = transactions["Date"]
		@amount = transactions["Amount"].to_f
		@description = transactions["Description"]
		@account = transactions["Account"]
	end

	def credit?
		@amount > 0 
	end

	def debit?
		@amount < 0
	end

	# def type
	# 	if credit? 

	def summary
		if credit?
		puts "#{@date} - CREDIT\t - #{format_currency(@amount.abs)}\t - #{@description} "
		else
			puts "#{@date} -  DEBIT\t - #{format_currency(@amount.abs)}\t - #{@description} "
		end
	end
end

class BankAccount
	attr_accessor :begin_bal, :name, :transactions

	def initialize(begin_balance, name)
		@begin_bal = begin_balance.to_f
		@name = name
		@transactions = []
	end

	def add_trans(transaction)
		@transactions << transaction
	end

	def summary
		@transactions.each do |t|
			t.summary
		end
	end

	def end_balance
		@end_balance = @begin_bal
		@transactions.each do |transaction|
			
			@end_balance += transaction.amount
		end
		@end_balance
	end
end

tr1 = BankTransaction.new({"Date"=>"10/2/2013", "Amount"=>"-29.99", "Description"=>"Amazon.com", "Account"=>"Business Checking"})

account = []

CSV.foreach('balances.csv', headers: true) do |row|
	account << row.to_hash
end

checking = BankAccount.new(account[0]["Balance"], account[0]["Account"])
purchasing = BankAccount.new(account[1]["Balance"], account[1]["Account"])


CSV.foreach('bank_data.csv', headers: true ) do |row|
			 row = row.to_hash
	 if row["Account"] == "Business Checking"
	 	checking.add_trans(BankTransaction.new(row.to_hash))
	 else
	 	purchasing.add_trans(BankTransaction.new(row.to_hash))
	 end
end

binding.pry

