require_relative "spec_helper"

describe Renderer do
  let(:config) { Configuration.from_inputs(["one", "two", "three"],
                                           Configuration.default_options,
                                           3) }

  it "renders selected matches" do
    search = Search.from_config(config).down
    renderer = Renderer.new(search)
    expect(renderer.render.choices).to eq [
      "3 > ",
      Text["one"],
      Text[:inverse, "two", :reset],
    ]
  end

  it "renders with no matches" do
    search = Search.from_config(config).append_search_string("z")
    renderer = Renderer.new(search)
    expect(renderer.render.choices).to eq [
      "0 > z",
      "",
      "",
    ]
  end

  it "respects the screen height" do
    config = Configuration.from_inputs(["One", "two", "three"],
                                       Configuration.default_options,
                                       2)
    search = Search.from_config(config)
    renderer = Renderer.new(search)
    expect(renderer.render.choices).to eq [
      "3 > ",
      Text[:inverse, "One", :reset],
    ]
  end

  it "highlights the matching text" do
    config = Configuration.from_inputs(["one", "two", "three"],
                                       Configuration.default_options,
                                       3)
    search = Search.from_config(config).append_search_string("o")
    renderer = Renderer.new(search)
    expect(renderer.render.choices).to eq [
      "2 > o",
      Text[:inverse, "", :red, "o", :default, "ne", :reset],
      Text["tw", :red, "o", :default, ""],
    ]
  end

  it "renders a scrolled list of choices" do
    config = Configuration.from_inputs(["one", "two", "three"],
                                       Configuration.parse_options(["--scrolloff"]),
                                       3)
    search = Search.from_config(config).down.down
    renderer = Renderer.new(search)
    expect(renderer.render.choices).to eq [
      "3 > ",
      Text["two"],
      Text[:inverse, "three", :reset]
    ]
  end
end
