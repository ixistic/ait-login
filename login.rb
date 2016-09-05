require 'net/http'
require 'openssl'
require 'nokogiri'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

operation = ARGV[0].to_s
if operation == 'login'
  uri = URI('https://auth-gw.ait.ac.th/auth/index.pl')
else
  uri = URI('https://auth-gw.ait.ac.th/auth/logoutpage.pl')
end

req = Net::HTTP::Post.new(uri)
req.set_form_data('username' => ENV['USERNAME'], 'password' => ENV['PASSWORD'])

res = Net::HTTP.start(uri.hostname, uri.port,:use_ssl => uri.scheme == 'https') do |http|
  http.use_ssl = true
  http.request(req)
end

case res
when Net::HTTPSuccess, Net::HTTPRedirection
  html_doc = Nokogiri::HTML(res.body)
  if !html_doc.css("font[face='Verdana, Arial, Helvetica, sans-serif']")[0].nil?
    puts html_doc.css("font[face='Verdana, Arial, Helvetica, sans-serif']")[0].content
  elsif !html_doc.css("p[align='center']")[0].nil?
    puts html_doc.css("p[align='center']")[0].content
  else
    puts "Login Successful"
  end
else
  puts res.value
end
