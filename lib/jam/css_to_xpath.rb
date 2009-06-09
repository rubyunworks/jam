
# css_to_xpath - generic CSS to XPath selector transformer
#
# * @author      Andrea Giammarchi
# * @license     Mit Style License
# * @blog        http://webreflection.blogspot.com/
# * @project     http://code.google.com/p/css2xpath/
# * @version     0.1 - Converts correctly every SlickSpeed CSS selector [http://mootools.net/slickspeed/]
# * @note        stand alone vice-versa subproject [http://code.google.com/p/css2xpath/]
# * @info        http://www.w3.org/TR/CSS2/selector.html
# * @credits     some tips from Aristotle Pagaltzis [http://plasmasturm.org/log/444/]
#

module Jam

  def self.css_to_xpath(css)
    CSStoXPath.css_to_xpath(css)
  end

  module CSStoXPath
    extend self

    RULES = []

    def rule(re_from, re_to=nil, &block)
      RULES << [re_from, re_to || block]
    end

    # add @ for attribs
    rule /\[([^\]~\$\*\^\|\!]+)(=[^\]]+)?\]/, '[@\1\2]'

    # multiple queries
    rule /\s*,\s*/, "|"

    # , + ~ >
    rule /\s*(\+|~|>)\s*/, '\1'

    # * ~ + >
    rule /([a-zA-Z0-9\_\-\*])~([a-zA-Z0-9\_\-\*])/ , '\1/following-sibling::\2'
    rule /([a-zA-Z0-9\_\-\*])\+([a-zA-Z0-9\_\-\*])/, '\1/following-sibling::*[1]/self::\2'
    rule /([a-zA-Z0-9\_\-\*])>([a-zA-Z0-9\_\-\*])/ , '\1/\2'

    # all unescaped stuff escaped
    rule /\[([^=]+)=([^'|"][^\]]*)\]/, '[\1=\'\2\']'

    # all descendant or self to //
    rule /(^|[^a-zA-Z0-9\_\-\*])(#|\.)([a-zA-Z0-9\_\-]+)/, '\1*\2\3'
    rule /([\>\+\|\~\,\s])([a-zA-Z\*]+)/, '$1//$2'
    rule /\s+\/\//, '//'

    # :first-child
    rule /([a-zA-Z0-9\_\-\*]+):first-child/, '*[1]/self::\1'

    # :last-child
    rule /([a-zA-Z0-9\_\-\*]+):last-child/, '\1[not(following-sibling::*)]'

    # :only-child
    rule /([a-zA-Z0-9\_\-\*]+):only-child/, '*[last()=1]/self::\1'

    # :empty
    rule /([a-zA-Z0-9\_\-\*]+):empty/, '\1[not(*) and not(normalize-space())]'

    # :not
    rule /([a-zA-Z0-9\_\-\*]+):not\(([^\)]*)\)/ do |s, a, b|
      return a.concat("[not(", css_to_xpath(b).gsub(/^[^\[]+\[([^\]]*)\].*$/, '\1'), ")]") 
    end

    # :nth-child
    rule /([a-zA-Z0-9\_\-\*]+):nth-child\(([^\)]*)\)/ do |s, a, b|
      case b
      when "n"
        return a
      when "even"
        return "*[position() mod 2=0 and position()>=0]/self::" + a
      when "odd"
        return a + "[(count(preceding-sibling::*) + 1) mod 2=1]"
      else
        b = (b || "0").gsub(/^([0-9]*)n.*?([0-9]*)$/, '\1+\2').split("+")
        b[1] = b[1] || "0"
        return "*[(position()-".concat(b[1], ") mod ", b[0], "=0 and position()>=", b[1], "]/self::", a)
      end
    end

    # :contains(selectors)
    rule /:contains\(([^\)]*)\)/ do |s, a|
      # return "[contains(css:lower-case(string(.)),'" + a.toLowerCase() + "')]"; // it does not work in firefox 3*/
      return "[contains(string(.),'" + a + "')]"
    end

    # |= attrib
    rule /\[([a-zA-Z0-9\_\-]+)\|=([^\]]+)\]/, '[@\1=\2 or starts-with(@\1,concat(\2,\'-\'))]'

    # *= attrib
    rule /\[([a-zA-Z0-9\_\-]+)\*=([^\]]+)\]/, '[contains(@\1,\2)]'

    # ~= attrib
    rule /\[([a-zA-Z0-9\_\-]+)~=([^\]]+)\]/, '[contains(concat(' ',normalize-space(@\1),' '),concat(' ',\2,' '))]'

    # ^= attrib
    rule /\[([a-zA-Z0-9\_\-]+)\^=([^\]]+)\]/, '[starts-with(@\1,\2)]'

    # $= attrib
    rule /\[([a-zA-Z0-9\_\-]+)\$=([^\]]+)\]/ do |s, a, b|
      return '[substring(@'.concat(a, ',string-length(@', a, ')-', b.length - 3, ')=', b, ']')
    end

    # != attrib
    rule /\[([a-zA-Z0-9\_\-]+)\!=([^\]]+)\]/, '[not(@\1) or @\1!=\2]'

    # ids and classes
    rule /#([a-zA-Z0-9\_\-]+)/ , '[@id=\'\1\']'
    rule /\.([a-zA-Z0-9\_\-]+)/, '[contains(concat(\' \',normalize-space(@class),\' \'),\' \1 \')]'

    # normalize multiple filters
    rule /\]\[([^\]]+)/, ' and (\1)'

    def css_to_xpath(css)
      RULES.each do |f, t|
        case t
        when Proc
          css = css.gsub(f, &t)
        else
          css = css.gsub(f, t)
        end
      end
      return "//" + css;
    end

  end

end

