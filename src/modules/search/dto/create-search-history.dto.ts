import { IsString, Length } from 'class-validator';

export class CreateSearchHistoryDto {
  @IsString()
  @Length(1, 255)
  query: string;
}
