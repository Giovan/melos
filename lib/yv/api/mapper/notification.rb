module YV
  module API
    module Mapper
      class Notification < Base

        class << self

          private

          def from_all(results)
            from_collection(results)
          end

          def from_collection(results)
            # If the data is a blank/empty array, return it
            return results if results.blank?
            results.items.collect do |item|
              map_to_instance(::Notification.new,item.merge(last_viewed_dt: results.last_viewed_dt))
            end
          end

          def map_to_instance(instance,results)
            instance = build_for_identifier(results.id,results,instance)

            instance.type             = results.id
            instance.created_dt       = results.created_dt
            instance.last_viewed_at   = results.last_viewed_dt

            # Base data
            base = results.base
            instance.action_url       = base.action_url
            instance.color            = base.color
            instance.moment_title     = t(base.title.l_str,base.title.l_args) # TODO: Localize

            instance.icons            = map_to_icons(results.base.images.icon)
            instance.avatars          = map_to_avatars(results.base.images.avatar)

            instance
          end

          def build_for_identifier(identifier,item_data,instance)
            user_data = case identifier
              
              when "notifications.friendships.offer.v1"
                item_data.extras.friendships_offer.user
              
              when "notifications.friendships.accept.v1"
                item_data.extras.friendships_accept.user
            end
            
            instance.user = build_user(user_data) unless user_data.nil?
            return instance
          end

          def build_user(user)
            SimpleUser.new(
              name:       user.name,
              user_name:  user.username,
              id:         user.id,
              avatars:    map_to_avatars(user.avatar)
            )
          end

        end
      end
    end
  end
end



# {"last_viewed_dt"=>"2013-10-31T02:52:41+00:00",
#  "items"=>
#   [{"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/b582dfcb764a5e719e7818628c6d203e_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/b582dfcb764a5e719e7818628c6d203e_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/b582dfcb764a5e719e7818628c6d203e_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/b582dfcb764a5e719e7818628c6d203e_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7481",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>"//www.bible.com/friends"}},
#       "color"=>"506737",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.friendships.accept",
#         "l_args"=>{"name"=>"Andy Knight"}}},
#     "created_dt"=>"2013-10-30T18:33:47+00:00",
#     "extras"=>
#      {"friendships_accept"=>
#        {"user"=>
#          {"username"=>"andyknight",
#           "id"=>7481,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/b582dfcb764a5e719e7818628c6d203e_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/b582dfcb764a5e719e7818628c6d203e_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/b582dfcb764a5e719e7818628c6d203e_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/b582dfcb764a5e719e7818628c6d203e_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7481",
#             "style"=>"circle"},
#           "name"=>"Andy Knight"}}},
#     "id"=>"notifications.friendships.accept.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7477",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>nil}},
#       "color"=>"fecc0e",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.comments.moment.mine.highlight",
#         "l_args"=>{"name"=>"Chris Vaughn"}}},
#     "created_dt"=>"2013-10-30T15:56:25+00:00",
#     "extras"=>
#      {"comments_moments_mine"=>
#        {"comment"=>{"id"=>1383148584304170},
#         "moment"=>{"kind"=>"highlight", "id"=>5521335346266112},
#         "user"=>
#          {"username"=>"chrisvaughn",
#           "id"=>7477,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7477",
#             "style"=>"circle"},
#           "name"=>"Chris Vaughn"}}},
#     "id"=>"notifications.comments.moments.mine.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7477",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>nil}},
#       "color"=>"824f2b",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.comments.moment.mine.note",
#         "l_args"=>{"name"=>"Chris Vaughn"}}},
#     "created_dt"=>"2013-10-30T15:52:16+00:00",
#     "extras"=>
#      {"comments_moments_mine"=>
#        {"comment"=>{"id"=>138314833528790},
#         "moment"=>{"kind"=>"note", "id"=>5713170060541952},
#         "user"=>
#          {"username"=>"chrisvaughn",
#           "id"=>7477,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7477",
#             "style"=>"circle"},
#           "name"=>"Chris Vaughn"}}},
#     "id"=>"notifications.comments.moments.mine.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7477",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>nil}},
#       "color"=>"fecc0e",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.comments.moment.mine.highlight",
#         "l_args"=>{"name"=>"Chris Vaughn"}}},
#     "created_dt"=>"2013-10-30T01:57:45+00:00",
#     "extras"=>
#      {"comments_moments_mine"=>
#        {"comment"=>{"id"=>1383098264650760},
#         "moment"=>{"kind"=>"highlight", "id"=>5521335346266112},
#         "user"=>
#          {"username"=>"chrisvaughn",
#           "id"=>7477,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7477",
#             "style"=>"circle"},
#           "name"=>"Chris Vaughn"}}},
#     "id"=>"notifications.comments.moments.mine.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7477",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>nil}},
#       "color"=>"824f2b",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.comments.moment.mine.note",
#         "l_args"=>{"name"=>"Chris Vaughn"}}},
#     "created_dt"=>"2013-10-30T01:57:23+00:00",
#     "extras"=>
#      {"comments_moments_mine"=>
#        {"comment"=>{"id"=>1383098242169260},
#         "moment"=>{"kind"=>"note", "id"=>5739886099300352},
#         "user"=>
#          {"username"=>"chrisvaughn",
#           "id"=>7477,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7477",
#             "style"=>"circle"},
#           "name"=>"Chris Vaughn"}}},
#     "id"=>"notifications.comments.moments.mine.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7477",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/highlight-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>nil}},
#       "color"=>"fecc0e",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.comments.moment.mine.highlight",
#         "l_args"=>{"name"=>"Chris Vaughn"}}},
#     "created_dt"=>"2013-10-30T00:03:09+00:00",
#     "extras"=>
#      {"comments_moments_mine"=>
#        {"comment"=>{"id"=>1383091388605300},
#         "moment"=>{"kind"=>"highlight", "id"=>5521335346266112},
#         "user"=>
#          {"username"=>"chrisvaughn",
#           "id"=>7477,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7477",
#             "style"=>"circle"},
#           "name"=>"Chris Vaughn"}}},
#     "id"=>"notifications.comments.moments.mine.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/c4bdd222af9661b65872bc30d9cdaf55_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/c4bdd222af9661b65872bc30d9cdaf55_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/c4bdd222af9661b65872bc30d9cdaf55_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/c4bdd222af9661b65872bc30d9cdaf55_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7486",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>"//www.bible.com/friends"}},
#       "color"=>"506737",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.friendships.accept",
#         "l_args"=>{"name"=>"Taylor Ketron"}}},
#     "created_dt"=>"2013-10-29T18:31:36+00:00",
#     "extras"=>
#      {"friendships_accept"=>
#        {"user"=>
#          {"username"=>"TaylorKetron",
#           "id"=>7486,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/c4bdd222af9661b65872bc30d9cdaf55_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/c4bdd222af9661b65872bc30d9cdaf55_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/c4bdd222af9661b65872bc30d9cdaf55_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/c4bdd222af9661b65872bc30d9cdaf55_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7486",
#             "style"=>"circle"},
#           "name"=>"Taylor Ketron"}}},
#     "id"=>"notifications.friendships.accept.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7477",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>nil}},
#       "color"=>"824f2b",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.comments.moment.mine.note",
#         "l_args"=>{"name"=>"Chris Vaughn"}}},
#     "created_dt"=>"2013-10-29T16:10:43+00:00",
#     "extras"=>
#      {"comments_moments_mine"=>
#        {"comment"=>{"id"=>1383063042534810},
#         "moment"=>{"kind"=>"note", "id"=>5739886099300352},
#         "user"=>
#          {"username"=>"chrisvaughn",
#           "id"=>7477,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7477",
#             "style"=>"circle"},
#           "name"=>"Chris Vaughn"}}},
#     "id"=>"notifications.comments.moments.mine.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7477",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/note-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>nil}},
#       "color"=>"824f2b",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.comments.moment.mine.note",
#         "l_args"=>{"name"=>"Chris Vaughn"}}},
#     "created_dt"=>"2013-10-28T23:35:17+00:00",
#     "extras"=>
#      {"comments_moments_mine"=>
#        {"comment"=>{"id"=>1383003315752740},
#         "moment"=>{"kind"=>"note", "id"=>5702558538530816},
#         "user"=>
#          {"username"=>"chrisvaughn",
#           "id"=>7477,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7477",
#             "style"=>"circle"},
#           "name"=>"Chris Vaughn"}}},
#     "id"=>"notifications.comments.moments.mine.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/437d4b36444fafd199b10587b0e39dbd_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/437d4b36444fafd199b10587b0e39dbd_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/437d4b36444fafd199b10587b0e39dbd_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/437d4b36444fafd199b10587b0e39dbd_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7474",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>"//www.bible.com/friends"}},
#       "color"=>"506737",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.friendships.accept",
#         "l_args"=>{"name"=>"Bryan Test"}}},
#     "created_dt"=>"2013-10-28T20:44:32+00:00",
#     "extras"=>
#      {"friendships_accept"=>
#        {"user"=>
#          {"username"=>"bdmtest",
#           "id"=>7474,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/437d4b36444fafd199b10587b0e39dbd_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/437d4b36444fafd199b10587b0e39dbd_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/437d4b36444fafd199b10587b0e39dbd_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/437d4b36444fafd199b10587b0e39dbd_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7474",
#             "style"=>"circle"},
#           "name"=>"Bryan Test"}}},
#     "id"=>"notifications.friendships.accept.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>
#          {"renditions"=>
#            [{"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#              "width"=>128,
#              "height"=>128},
#             {"url"=>
#               "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#              "width"=>512,
#              "height"=>512}],
#           "action_url"=>"//www.bible.com/users/7477",
#           "style"=>"circle"},
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/friendship-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>"//www.bible.com/friends"}},
#       "color"=>"506737",
#       "action_url"=>nil,
#       "title"=>
#        {"l_str"=>"notifications.friendships.offer",
#         "l_args"=>{"name"=>"Chris Vaughn"}}},
#     "created_dt"=>"2013-10-28T16:31:15+00:00",
#     "extras"=>
#      {"friendships_offer"=>
#        {"user"=>
#          {"username"=>"chrisvaughn",
#           "id"=>7477,
#           "avatar"=>
#            {"renditions"=>
#              [{"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_24x24.png",
#                "width"=>24,
#                "height"=>24},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_48x48.png",
#                "width"=>48,
#                "height"=>48},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_128x128.png",
#                "width"=>128,
#                "height"=>128},
#               {"url"=>
#                 "//d1c1qrnexsp66u.cloudfront.net/users/images/2e4df7375403ea32560dfd36f0982a52_512x512.png",
#                "width"=>512,
#                "height"=>512}],
#             "action_url"=>"//www.bible.com/users/7477",
#             "style"=>"circle"},
#           "name"=>"Chris Vaughn"}}},
#     "id"=>"notifications.friendships.offer.v1"},
#    {"base"=>
#      {"images"=>
#        {"avatar"=>nil,
#         "icon"=>
#          {"renditions"=>
#            [{"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/system-white-24.png",
#              "width"=>24,
#              "height"=>24},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/system-white-36.png",
#              "width"=>36,
#              "height"=>36},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/system-white-48.png",
#              "width"=>48,
#              "height"=>48},
#             {"url"=>
#               "//commondatastorage.googleapis.com/static-youversionapi-com/moments/icons/system-white-72.png",
#              "width"=>72,
#              "height"=>72}],
#           "action_url"=>nil}},
#       "color"=>"222222",
#       "action_url"=>nil,
#       "title"=>{"l_str"=>"notifications.system.test", "l_args"=>{}}},
#     "created_dt"=>"2013-09-03T12:34:37+00:00",
#     "extras"=>nil,
#     "id"=>"notifications.system.test.v1"}],
#  "new_count"=>0}