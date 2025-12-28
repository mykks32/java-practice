import {ICarObserver} from "../interfaces/ICarObserver";

export class InsuranceSystem implements ICarObserver {
    public update(status: string): void {
        console.log("Insurance notified: " + status);
    }
}

export class ServiceCenter implements ICarObserver {
    public update(status: string): void {
        console.log("Service Center notified: " + status);
    }
}

export class CarStatusNotifier {
    private readonly observers: Array<ICarObserver> = [];

    public addObserver(observer: ICarObserver): void {
        this.observers.push(observer);
    }

    public notifyAll(status: string): void {
        this.observers.forEach(observer => {
            observer.update(status);
        })
    }
}