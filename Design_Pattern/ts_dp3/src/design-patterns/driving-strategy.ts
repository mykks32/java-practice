import {IDrivingStrategy} from "../interfaces/IDrivingStrategy";

export class EcoMode implements IDrivingStrategy {
    public drive(): void {
        console.log("Eco Driving Mode");
    }
}

export class SportMode implements IDrivingStrategy {
    public drive(): void {
        console.log("Sports Driving Mode");
    }
}

export class CarController {
    private drivingStrategy: IDrivingStrategy

    public setDrivingStrategy(drivingStrategy: IDrivingStrategy): void {
        this.drivingStrategy = drivingStrategy;
    }

    public drive(): void {
        this.drivingStrategy.drive();
    }
}