SimpleCaptcha.setup do |c|
  # default: 100x28
  c.image_size = '80x34'

  # default: 5
  c.length = 5

  # default: simply_blue
  # possible values:
  # 'embosed_silver',
  # 'simply_red',
  # 'simply_green',
  # 'simply_blue',
  # 'distorted_black',
  # 'all_black',
  # 'charcoal_grey',
  # 'almost_invisible'
  # 'random'
  c.image_style = 'random'

  # default: low
  # possible values: 'low', 'medium', 'high', 'random'
  c.distortion = 'low'
end