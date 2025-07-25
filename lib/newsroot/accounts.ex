defmodule Newsroot.Accounts do
  use Ash.Domain,
    otp_app: :newsroot

  resources do
    resource Newsroot.Accounts.User
  end
end
