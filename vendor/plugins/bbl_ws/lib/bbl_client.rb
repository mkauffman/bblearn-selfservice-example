require 'httpclient' # used to make a post HTTP call to SIAPI with the XML 
require 'digest' # used to create the MD5 checksum for the HTTP post

module client 
  def self.post(xml)
    secret = AppConfig.siapi_secret
    adapter = AppConfig.siapi_adapter
    action = AppConfig.siapi_action
    option = AppConfig.siapi_option
    timestamp = Time.now.to_i
    glcid = AppConfig.siapi_glcid
    post_url = AppConfig.siapi_post_url
    
    client = HTTPClient.new
    client.ssl_config.ciphers = 'ALL'
    checksum = calculate_checksum(xml)
    macData = action+option+timestamp.to_s()+checksum.to_s()+glcid
    mac = calculate_mac(macData, secret)
    file_name = "upload"+timestamp.to_s()+checksum.to_s()
    fref = Tempfile.new(file_name) 
    fref.puts xml
    fref.seek(0, IO::SEEK_SET)
    params = {
          :adapter => adapter,
          :action => action,
          :option => option,
          :timestamp => timestamp,
          :auth => mac,
          :checksum => checksum, 
          :glcid => glcid,
          :Flie => fref
      # For the curious, a sketch of the Flie: http://www.elfwood.com/art/d/i/diamondhoof/flie_sketch.jpg
    }
    
    @res = client.post(post_url, params)
    fref.close!()
    return @res
  end #doPost
  
  def self.calculate_checksum(data)
    checksum = 0
    data.each_byte do |x|
      checksum = checksum + x  
    end     
    return checksum
  end #calculateChecksum
  
  def self.calculate_mac(data, secret)
    checksum = calculate_checksum(data)
    md5 = Digest::MD5.hexdigest(checksum.to_s()+secret)
    mac = md5.upcase
  end #calculateMac
end # module client