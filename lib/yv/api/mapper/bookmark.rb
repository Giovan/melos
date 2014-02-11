module YV
  module API
    module Mapper
      class Bookmark < Base

        class << self

          def from_all(results)
            from_collection(results)
          end

          def from_collection(results)
            # If the data is a blank/empty array, return it
            return results if results.blank?
            
            collection = results.moments.collect do |moment|
              map_to_instance(::Bookmark.new, moment)
            end
          end

          def from_delete(results)
            return results
          end

          def from_create(instance, results)
            from_default(instance,results)
          end

          def from_update(instance, results)
            from_default(instance,results)
          end

          def from_find(instance, results)
            from_default(instance,results)
          end

          def from_default(instance,results)
            map_to_instance(instance,results)
          end

          def map_to_instance(instance,results)
            instance.id               = results.id.to_s
            instance.kind_id          = results.kind_id
            instance.kind_color       = results.kind_color
            instance.color            = results.extras.color
            instance.labels           = results.extras.labels.nil? ? [] : results.extras.labels
            instance.title            = results.extras.title
            instance.moment_title     = t(results.base.title["l_str"],results.base.title["l_args"])
            instance.references       = results.extras.references

            # Common moment elements
            instance                  = map_to_user_fields(instance,results.extras.user)
            instance.icons            = map_to_icons(results.base.images.icon)
            instance.avatars          = map_to_avatars(results.base.images.avatar)
            
            instance.comments         = map_to_comments(results.commenting.comments)
            instance.commenting       = results.commenting.enabled
            instance.comments_count   = results.commenting.total

            instance                  = map_to_like_fields(instance,results.liking)
            instance.created_dt       = results.created_dt
            instance
          end

        end

      end
    end
  end
end