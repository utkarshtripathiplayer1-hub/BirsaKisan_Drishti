from db.mongo import database


user_conversations = database["user_conversations"]

conversation_messages = database["conversation_messages"]

user_preferences = database["user_preferences"]

users = database["users"]  
crop_profile = database["CROP_PROFILE_COLLECTION"]
feedback = database["feedback"]