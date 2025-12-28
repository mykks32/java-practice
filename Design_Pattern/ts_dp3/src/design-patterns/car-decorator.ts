import {IBasicCar} from "../interfaces/IBasicCar";

export class BaseCar implements IBasicCar {
    public feature(): void {
        console.log("Basic Car");
    }
}

abstract class CarDecorator implements IBasicCar {
    protected car: IBasicCar;

    protected constructor(car: IBasicCar) {
        this.car = car;
    }

    public abstract feature(): void;
}

export class GPSDecorator extends CarDecorator {
    constructor(car: IBasicCar) {
        super(car);
    }

    public feature(): void {
        this.car.feature()
        console.log(" + GPS feature");
    }
}

export class MusicDecorator extends CarDecorator {
    constructor(car: IBasicCar) {
        super(car);
    }

    public feature(): void {
        this.car.feature()
        console.log(" + Music feature);")
    }
}