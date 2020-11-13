# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     QuoteApi.Repo.insert!(%QuoteApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias QuoteApi.Repo
alias QuoteApi.Directory.Quote

Repo.insert! %Quote{quote: "Act as if what you do makes a difference. IT DOES.", author_name: "William James", tag: "inspiring"}
Repo.insert! %Quote{quote: "Limit your always' and your nevers.", author_name: "Amy Poehler", tag: "life advice"}
Repo.insert! %Quote{quote: "Impossible is a word to be found only in the dictionary of fools.", author_name: "Napoleon Bonaparte", tag: "inspiring"}
