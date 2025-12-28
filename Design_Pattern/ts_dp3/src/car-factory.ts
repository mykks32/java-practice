import {Car} from "./interfaces/ICar";
import {CarTypesEnum} from "./enums/car-types-enum";

class Sedan implements Car {
    public drive(): void {
        console.log("Driving Sedan");
    }
}

class Suv implements Car {
    public drive(): void {
        console.log("Driving Suv");
    }
}

export class CarFactory {
    public static createCar(carType: CarTypesEnum): Car | null {
        switch (carType) {
            case CarTypesEnum.SEDAN:
                return new Sedan();
            case CarTypesEnum.SUV:
                return new Suv();
            default:
                console.error("CarFactory.createCar: Invalid type '" + carType + "'");
                return null;
        }
    }
}
