module Jam

  def self.css_to_xpath(rule)
    regElement    = /^([#.]?)([a-z0-9\\*_-]*)((\|)([a-z0-9\\*_-]*))?/i
    regAttr1      = /^\[([^\]]*)\]/i
    regAttr2      = /^\[\s*([^~=\s]+)\s*(~?=)\s*"([^"]+)"\s*\]/i
    regPseudo     = /^:([a-z_-])+/i
    regCombinator = /^(\s*[>+\s])?/i
    regComma      = /^\s*,/i

    index = 1;
    parts = ["//", "*"]
    lastRule = nil

    while rule.length && rule != lastRule
      lastRule = rule

      # Trim leading whitespace
      rule = rule.gsub(/^\s*|\s*$/, "")  #.replace
      break if rule.length == 0

      # Match the element identifier
      m = regElement.match(rule)
      if m
        if !m[1]
          # XXXjoe Namespace ignored for now
          if m[5]
            parts[index] = m[5]
          else
            parts[index] = m[2]
          end
        elsif (m[1] == '#')
            parts.push("[@id='" + m[2] + "']") 
        elsif (m[1] == '.')
            parts.push("[contains(@class, '" + m[2] + "')]") 
        end        
        rule = rule.substr(m[0].length)
      end

      # Match attribute selectors
      m = regAttr2.match(rule)
      if m
        if m[2] == "~="
          parts.push("[contains(@" + m[1] + ", '" + m[3] + "')]")
        else
          parts.push("[@" + m[1] + "='" + m[3] + "']")
        end
        rule = rule.substr(m[0].length)
      else
        m = regAttr1.match(rule)
        if m
          parts.push("[@" + m[1] + "]")
          rule = rule.substr(m[0].length)
        end
      end

      # Skip over pseudo-classes and pseudo-elements, which are of no use to us
      m = regPseudo.match(rule)
      while m
        rule = rule.substr(m[0].length)
        m = regPseudo.match(rule)
      end

      # Match combinators
      m = regCombinator.match(rule)
      if m && m[0].length
        if m[0].index(">")
          parts.push("/")
        elsif m[0].index("+")
          parts.push("/following-sibling::")
        else
          parts.push("//")
        end
        index = parts.length
        parts.push("*")
        rule = rule.substr(m[0].length)
      end

      m = regComma.match(rule)
      if m
        parts.push(" | ", "//", "*")
        index = parts.length - 1
        rule = rule.substr(m[0].length)
      end
    end
    
    xpath = parts.join("")
    return xpath
  end

end #module Jam


class String

  #
  def substr(start, ending=-1)
    str = self[start..ending]
    self[start..ending] = ''
    str
  end

end

