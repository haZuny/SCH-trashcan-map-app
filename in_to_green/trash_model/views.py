# from msilib.schema import Shortcut
# from rest_framework import viewsets
# from trash_model.serializers import TrashSerializer
# from trash_model.models import Trash

from typing import ByteString
from django.shortcuts import render
from rest_framework.response import Response
from .models import Trash
from rest_framework.views  import APIView
from .serializers import TrashSerializer
from django.http import Http404

import io   # 이미지 관련
import os
from django.core.files import File
from django.http import FileResponse

import chardet
import base64

from .deeplearning.Resnet_extract_resnet import *

# Create your views here.
# class TrashViewSet(viewsets.ModelViewSet):
#     queryset = Trash.objects.all()
#     serializer_class = TrashSerializer


# 전체 게시물
class TrashList(APIView):
    def post(self, request):
        serializer = TrashSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()

            print('딥러닝')
            
            # 쓰레기통
            if model('.'+serializer.data['image']) == 1:
                return Response(serializer.data)
            else:
                print("쓰레기아님")
                Trash.objects.get(pk=serializer.data['id']).delete()
                return Response()

        return Response(serializer.errors)

    def get(self, request):
        quryset = Trash.objects.all()
        serizer = TrashSerializer(quryset, many=True)

        # 전송할 데이터 가공
        sendData = []
        for obj in serizer.data:
            newObj = {} # 최종적으로 보낼 객체
            imgBin = "" # 이미지 바이너리
            for key, value in obj.items():
                if(key != 'image'):
                    # f = open('.'+obj['image'], 'rb')
                    # newObj[key] = ''+ str(f.read())
                    newObj[key] = value
                else:
                    print(value)
            sendData.append(newObj)
    
        return Response(sendData)
        

# 특정 게시물
class TrashDetail(APIView):
    def get_object(self, pk):
        try:
            return Trash.objects.get(pk=pk)
        except Trash.DoesNotExist:
            raise Http404


    def get(self, request, pk):
        trash = self.get_object(pk)
        seriizer = TrashSerializer(trash)
        
        # get
        if request.method == "GET":
            # 이미지 파일
            imgF = open('.'+seriizer.data['image'], 'rb')
            data = imgF.read()
            # print(data)
            
            sendData = []
            obj = {}
            obj['img'] = base64.b64encode(data)
            sendData.append(obj)
            # respense = FileResponse(imgF)

            return Response(sendData)

        elif request.method == "HEAD":
            print("와이")
            trash.delete()
            return Response()

    def delete(self, requst, pk):
        trash = self.get_object(pk)
        seriizer = TrashSerializer(trash)

        trash.delete()
        return Response()