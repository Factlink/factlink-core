# coding: utf-8

require 'approvals'
require 'stringex'

describe Stringex do
  describe ".to_url" do
    # this is needed for slugs in topics and channels
    # we might want to improve this at some point, as some
    # characters don't get properly encoded
    it "should make slugs in a consistent way" do
      whitespace = [
        "None",
        " SpaceBefore",
        "SpaceAfter ",
        " SpaceAround ",
        "Space Inbetween",

        "\tTabBefore",
        "TabAfter\t",
        "\tTabAround\t",
        "Tab\tInbetween",

        "   SpacesBefore",
        "SpacesAfter   ",
        "   SpacesAround   ",
        "Spaces   Inbetween",

        "\nNewlineBefore",
        "NewlineAfter\n",
        "\nNewlineAround\n",
        "Newline\nInbetween",
      ]

      utf8 = [
        'snow ☃ man',
        "copy \u00A9 right",
        "three ⅜ eights"
      ]

      punctuation = [
        "punct … uation",
        "punct “ uation",
        "punct ; uation"
      ]

      dots = [
        ".DotBefore",
        "DotAfter.",
        ".DotAround.",
        "Dot.Inbetween",

        "Dot in abbreviation T.E.S.T"
      ]

      special_chars = [
        "a#a",
        "a!a",
        "a@a",
        "a#a",
        "a$a",
        "a%a",
        "a^a",
        "a&a",
        "a*a",
        "a(a",
        "a)a",
        "a{a",
        "a}a",
        "a~a",
        "a`a"
      ]

      dashes = [
        "-DashBefore",
        "DashAfter-",
        "-DashAround-",
        "Dash-Inbetween",
      ]

      actual_problems = [
        "Story.nl - Sanoma Media Netherlands B.V."
      ]

      output = [
        whitespace,
        utf8,
        punctuation,
        dots,
        special_chars,
        dashes,
        actual_problems
      ].flatten.map(&:to_url)

      Approvals.verify(output, name: 'stringex slugs')
    end
  end
end
