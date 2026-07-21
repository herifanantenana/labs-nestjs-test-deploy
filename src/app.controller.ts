import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('test-run')
  getTestRun(): string {
    return 'Test Run';
  }

  @Get('hello')
  getHelloWorld(): { message: string } {
    return { message: 'Hello World' };
  }
}
