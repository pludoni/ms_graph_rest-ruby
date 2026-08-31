require 'uri'

module MsGraphRest
  # Replacement for CGI.parse, which Ruby 4.0 dropped along with the rest of the
  # non-escaping parts of the cgi library.
  module QueryParams
    module_function

    # @return [Hash{String => Array<String>}] values per key, as CGI.parse returned them
    def parse(query)
      return {} if query.nil? || query.empty?

      URI.decode_www_form(query).each_with_object({}) do |(key, value), out|
        (out[key] ||= []) << value
      end
    end
  end
end
