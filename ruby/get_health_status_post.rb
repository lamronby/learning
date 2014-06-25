
require 'net/http'
require 'net/https'

# Create the http object
target_host = "qa-phoenix.socsuite.com"
http = Net::HTTP.new(target_host, 443)
http.use_ssl = true
path = '/Services/HealthStatusService.svc/HealthStatusService'

# Create the SOAP Envelope
data = <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ns="http://www.troppussoftware.com/service/2010/12/">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
        <Security s:mustUnderstand="1" xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" xmlns:s="s">
            <UsernameToken u:Id="b08e7355-f4a1-4b42-849e-5ecdf9bb7491">
                <Username>healthstatususer</Username>
                <Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">049B382DE77D75AE620027833C431EFA54340FA6</Password>
            </UsernameToken>
        </Security>
   <wsa:Action>http://www.troppussoftware.com/service/2010/12/IHealthStatusService/GetHealthStatus</wsa:Action></soap:Header>
   <soap:Body>
      <ns:GetHealthStatus/>
   </soap:Body>
</soap:Envelope>
EOF

# Set Headers
headers = {
  'Content-Type' => 'application/soap+xml;charset=UTF-8;action="http://www.troppussoftware.com/service/2010/12/IHealthStatusService/GetHealthStatus"',
  'Host' => target_host
}

# Post the request
resp, data = http.post(path, data, headers)

# Output the results
puts 'Code = ' + resp.code
puts 'Message = ' + resp.message
resp.each { |key, val| puts key + ' = ' + val }
puts data

