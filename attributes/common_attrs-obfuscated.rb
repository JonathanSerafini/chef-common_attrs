
# Hash of key => boolean values where the key is a period separated path
# to the attribute to obfuscate prior to sending the data to chef server.
# 
# @since 0.1.2
# @example
# ```json
# {
#   "plain": {
#     "text": {
#       "secret": "value"
#     }
#   },
#   "common_attrs": {
#     "obfuscated": {
#       "plain.text.secret": true
#     }
#   }
# }
# ```
default['common_attrs']['obfuscated'] = {}
