class PayPal
  def initialize(reference, description, amount, tax=0)
    @reference = reference
    @description = description
    @amount = amount
    @tax = tax
  end

  def form(*args)
    form = <<-EOS.strip_heredoc
    <form accept-charset="UTF-8" action="#{ENV['PAYPAL_URL']}" id="paypal_form" method="post">
      <input type="hidden" name="cmd" value="_s-xclick">
      <input type="hidden" name="encrypted" value="#{encrypted}">
    </form>
    EOS

    form.html_safe
  end

  def encrypted
    signed = OpenSSL::PKCS7::sign(
      OpenSSL::X509::Certificate.new(
        File.read(ENV["PAYPAL_APP_CERT"])),
      OpenSSL::PKey::RSA.new(
        File.read(ENV["PAYPAL_APP_KEY"]), ''),
      values.map { |k, v| "#{k}=#{v}" }.join("\n"),
      [], OpenSSL::PKCS7::BINARY)

    OpenSSL::PKCS7::encrypt(
      [OpenSSL::X509::Certificate.new(
        File.read(ENV["PAYPAL_CERT"]))],
      signed.to_der,
      OpenSSL::Cipher::Cipher::new("DES3"),
      OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end

  def values
    @values ||=
      {
        business: ENV["PAYPAL_ACCOUNT"],
        cmd: "_xclick",
        item_name: @description,
        amount: @amount,
        tax: @tax,
        no_note: 1,
        no_shipping: 1,
        currency_code: "USD",
        custom: @reference,
        return: ENV["PAYPAL_SUCCESS_URL"],
        cancel_return: "#{ENV["PAYPAL_CANCEL_URL"]}?reference=#{ENV["PAYPAL_INVOICE_PREFIX"]}#{@reference}",
        notify_url: ENV["PAYPAL_NOTIFY_URL"],
        bn: "IHP_ST",
        rm: "2",
        invoice: "#{ENV["PAYPAL_INVOICE_PREFIX"]}#{@reference}",
        cert_id: ENV["PAYPAL_APP_CERT_ID"]
      }
  end
end
