class AnsibleVaultPassClient < Formula
  homepage "https://github.com/bkahlert/ansible-vault-pass-client"
  # url "https://ftp.gnu.org/gnu/wget/wget-1.15.tar.gz"
  # sha256 "52126be8cf1bddd7536886e74c053ad7d0ed2aa89b4b630f76785bac21695fcd"

  def install
    bin.install "ansible-vault-pass-client"
  end
end
