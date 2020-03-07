#= require active_admin/base
#= require ./app
#= require marked
#= require to-markdown
#= require simditor
#= require simditor-markdown
#= require simditor-video
#= require jquery.Jcrop
#= require jquery-ui/widgets/sortable
#= require jquery.remotipart
#= require fancybox
#= require best_in_place
#= require jquery.purr
#= require best_in_place.purr
#= require cropper
#= require jquery.colorbox-min
#= require_tree ./admin
#= require Chart.bundle
#= require chartkick

$(document).ready ->
  jQuery(".best_in_place").best_in_place()
