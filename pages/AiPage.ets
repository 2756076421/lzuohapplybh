import { SparkService } from '../services/SparkService';
import image from '@ohos.multimedia.image'
import buffer from '@ohos.buffer'
import promptAction from '@ohos.promptAction'

@Component
export struct AiPage {
  private sparkService: SparkService = new SparkService();
  @State analysisResult: string = '';

  async handleImageAnalysis(image: image.PixelMap) {
    try {
      // 将图片转换为Base64
      let imageBase64 = await this.convertImageToBase64(image);
      
      // 调用星火API
      this.analysisResult = await this.sparkService.analyzeImage(imageBase64);
      
      // 显示结果
      promptAction.showToast({
        message: '分析完成',
        duration: 2000
      });
    } catch (error) {
      console.error('处理失败:', error);
      promptAction.showToast({
        message: '分析失败，请重试',
        duration: 2000
      });
    }
  }

  private async convertImageToBase64(pixelMap: image.PixelMap): Promise<string> {
    try {
      // 创建图片打包选项
      let imagePackingOption = {
        format: "image/jpeg",
        quality: 90
      };

      // 将PixelMap打包成Buffer
      let imageBuffer = await pixelMap.getImagePackingBuffer(imagePackingOption);
      
      // 将Buffer转换为Base64字符串
      let base64String = buffer.from(imageBuffer).toString('base64');
      
      return base64String;
    } catch (error) {
      console.error('图片转换失败:', error);
      throw error;
    }
  }

  build() {
    // 在界面中添加显示结果的组件
    Column() {
      // 现有的UI组件...
      
      if (this.analysisResult) {
        Text(this.analysisResult)
          .fontSize(16)
          .margin({ top: 20 })
          .padding(10)
      }
    }
  }
} 