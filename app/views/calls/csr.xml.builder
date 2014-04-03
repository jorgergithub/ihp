xml.instruct!
xml.Response do
  xml.Say "Please wait while we connect you to a customer service representative", voice: "woman"
  xml.Dial(@csr.phone, callerId: @caller_id)
end
