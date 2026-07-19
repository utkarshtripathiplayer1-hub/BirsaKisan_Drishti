from app.repositories.crop_repository import (
    crop_repository
)

from app.repositories.active_crop_repository import (
    active_crop_repository
)


class MyFarmRepository:

    async def get_latest_crop(
        self,
        user_id: str
    ):

        return await crop_repository.get_latest_by_user(
            user_id
        )

    async def get_active_crop(
        self,
        user_id: str
    ):

        return await active_crop_repository.get_active_crop(
            user_id
        )


my_farm_repository = MyFarmRepository()